Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3DSSgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:36:33 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54749 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab3DSSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:36:30 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2013 14:36:30 EDT
Message-ID: <51718D24.3020902@gmail.com>
Date: Fri, 19 Apr 2013 20:29:56 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        rt2x00 Users List <users@rt2x00.serialmonkey.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next V2] rt2x00: Use more current logging styles,
 shrink object size
References: <1366360406.3901.10.camel@joe-AO722>  <CAL1gcdOMtbzxCVLNvDK_CD-M+_SdAeL3Sja9khO9+G2bNOCz1g@mail.gmail.com>  <1366365149.3901.15.camel@joe-AO722> <1366385620.3901.28.camel@joe-AO722>
In-Reply-To: <1366385620.3901.28.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Apr 2013 18:30:16.0261 (UTC) FILETIME=[F02BBF50:01CE3D2B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/13 17:33, Joe Perches wrote:
> Reduce object space ~2% using more current logging styles.
> 
> Neaten and simplify logging macros.
> Use wiphy_<level> where appropriate.
> Coalesce formats.
> 
> Convert ERROR/WARNING/INFO macros to rt2x00_<level>
> Convert EEPROM to rt2x00_eeprom_dbg
> Convert PROBE_ERROR to rt2x00_probe_err
> Convert DEBUG to rt2x00_dbg
> Convert EEPROM to rt2x00_eeprom_dbg
> 
> $ size drivers/net/wireless/rt2x00/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  245639	  71696	  69584	 386919	  5e767	drivers/net/wireless/rt2x00/built-in.o.new
>  240609	  70096	  68944	 379649	  5cb01	drivers/net/wireless/rt2x00/built-in.o.new.nodyndbg
>  240609	  70096	  68944	 379649	  5cb01	drivers/net/wireless/rt2x00/built-in.o.new.no_rt2x00_debug
>  249198	  70096	  70352	 389646	  5f20e	drivers/net/wireless/rt2x00/built-in.o.old
>  249198	  70096	  70352	 389646	  5f20e	drivers/net/wireless/rt2x00/built-in.o.old.nodyndbg
>  244222	  70096	  69712	 384030	  5dc1e	drivers/net/wireless/rt2x00/built-in.o.old.no_rt2x00_debug
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> V2 differences:
> 
> Correct copy/paste error in rt2x00_info/warn macros
> Reorder macro definitions
> Use embedded prefix in rt2x00_eeprom_dbg
> 
> Object size increased from v1 ~100 bytes x86/32.
> Object size may be slightly smaller this way for x86/64
> 
>
---
Gertjan
