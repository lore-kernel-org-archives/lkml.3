Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbaLJVlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:41:52 -0500
Received: from ja.ssi.bg ([178.16.129.10]:49771 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932698AbaLJVlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:41:51 -0500
Date: Wed, 10 Dec 2014 23:41:34 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
In-Reply-To: <5486CD9D.4060107@smart-weblications.de>
Message-ID: <alpine.LFD.2.11.1412102331230.4043@ja.home.ssi.bg>
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com> <alpine.LFD.2.11.1412042338370.4841@ja.home.ssi.bg> <5481173A.9060308@smart-weblications.de> <alpine.LFD.2.11.1412051126090.2522@ja.home.ssi.bg> <5481B944.2000002@smart-weblications.de>
 <alpine.LFD.2.11.1412072019410.1885@ja.home.ssi.bg> <54858948.2060007@smart-weblications.de> <alpine.LFD.2.11.1412082234350.2401@ja.home.ssi.bg> <5486CD9D.4060107@smart-weblications.de>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Tue, 9 Dec 2014, Smart Weblications GmbH - Florian Wiessner wrote:

> I rebuild everything with the two provided patches and still get:
> 
> [  512.475449] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000014
> [  512.481277] IP: [<ffffffffa013d470>] nf_ct_seqadj_set+0x60/0x90 [nf_conntrack]

	Same place, hm...

> [  512.485323] CPU: 4 PID: 28142 Comm: vsftpd Not tainted 3.12.33 #5

	Above "#5" is same as previous oops. It means kernel
is not updated. Or you updated only the IPVS modules after
applying the both patches?

	You can also try without FTP tests to see if there
are oopses in xfrm, so that we can close this topic and then
to continue for the FTP problem on IPVS lists without
bothering non-IPVS people.

Regards

--
Julian Anastasov <ja@ssi.bg>
