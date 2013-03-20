Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3CTUnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:43:37 -0400
Received: from nm.newmedia-net.de ([217.113.179.122]:49264 "EHLO
	webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab3CTUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:43:36 -0400
Message-ID: <514A1F7A.6090407@dd-wrt.com>
Date: Wed, 20 Mar 2013 21:43:38 +0100
From: "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 12/48] signal: always clear sa_restorer on execve
References: <514A07DC.60708@dd-wrt.com>
In-Reply-To: <514A07DC.60708@dd-wrt.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.03.2013 20:02, schrieb Sebastian Gottschall (DD-WRT):
> Hello
>
> The patch for sa_restorer will break mips builds, since sa_restorer 
> isnt defined as field within the struct, but the MACRO is.
> so use the __ARCH_HAS_SA_RESTORER way which is implemented in that way 
> in linux 3.9 or simply revert the patch
>
>
> regards,
> Sebastian Gottschall
>
> -- 
> Mit freundlichen Grüssen / Regards
>
> Sebastian Gottschall / CTO
>
> NewMedia-NET GmbH - DD-WRT
> Firmensitz:  Berliner Ring 101, 64625 Bensheim
> Registergericht: Amtsgericht Darmstadt, HRB 25473
> Geschäftsführer: Peter Steinhäuser, Christian Scheele
> http://www.dd-wrt.com
> email: s.gottschall@dd-wrt.com
> Tel.: +496251-582650 / Fax: +496251-5826565
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

