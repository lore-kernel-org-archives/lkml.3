Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3ARO7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:59:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3ARO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:59:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 67/76] ARC: [Review] Multi-platform image #1: Kconfig enablement
Date: Fri, 18 Jan 2013 14:59:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-68-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-68-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181459.11758.arnd@arndb.de>
X-Provags-ID: V02:K0:8yEMPR5Qs7CXZ6rTlPCRET2VJ8YebxMYPJPZXPOciGw
 DTwlwBdNg+sSdFwMhJ3s+5Z5W/I6MJlxyr6nbHLu0r/FROX4zP
 wl8NVUyCiwmxeWb60Mj/RhrdF6uQtB0AOwIQ91q9Wp+eHogVRN
 Kio0Otg+ljMTnpT4EB/co3q1g540ZpkRbrM3a2bpiWunP3+f60
 koPl7BY7ROZBQDhkhKC5SGg+wht8RWkKNaBNU4TVVLsyErxu++
 2BeRxch5jZAIcweHcmCv7z1Gl7TgwX9K0RiXb6QebDXBjRud5N
 vRNcptwYxyF1yi5xQlawThVxqAruEIi2Eatb/1ZdZbGpOyexRr
 rqLidNbDiA4ch2J1QlSA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> This mini patchseries addresses the lack of multi-platform-image support
> in ARC port.
> 
> Older build system only supported one platform(soc) to build at a time
> and further only one board of that platform could be built. There was no
> technical reason for that - we just didn't have the need.
> 
> So the first step towards multi-platform (and multi-board) builds it to
> allow build system to do that.
> 
> So as applicable, <choice .. endchoice> => <menu .. endmenu>
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
