Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab3HBNJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:09:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3HBNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:09:45 -0400
Date: Fri, 2 Aug 2013 15:09:38 +0200
From: Heinz Diehl <htd@fritha.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Frantisek Hrbata <fhrbata@redhat.com>, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, kernel-team@fedoraproject.org
Subject: Re: NULL pointer dereference in xhci_free_dev
Message-ID: <20130802130938.GA4495@fritha.org>
References: <20130507140333.GB3380@dhcp-26-164.brq.redhat.com>
 <20130509221559.GD10305@xanatos>
 <20130510065644.GA3320@dhcp-26-164.brq.redhat.com>
 <20130511140925.GA9240@fritha.org>
 <20130726192609.GC15302@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726192609.GC15302@xanatos>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc
X-Mailer: Mew version 6.5 on Emacs 24.2.1 / Mule 6.0 (HANACHIRUSATO)
X-Provags-ID: V02:K0:QNzpfMcodLMCuwIcy7WhNXjMBcDXsmP8UJOdpGsTsor
 yWPoLaGSenBrcRcsmocCKsJdfItKGZPhmP6wu6QvDuskeDEpaq
 aRfhQ0/UdmyfNuPKg5+lJzVFYE7rpw84aYQ2UXIhy+Es0G59NK
 iGaFMK2ozTyJZfd3K+ayh2gr7ufWr6QTL1n7tk08PAnw/XPDAs
 9Ep/4WZuZdk4YqFautlnoquxKZYHaK1HinxAY7l50Tf0nVNpum
 0KmooF/18t3Z3wBTef5bK5trDDTLMLNTV3cjT6n+hlmLG4+Lqw
 axRpOjOzooz5t83cO7ep09s4wAI4mu+/6deHij4guxBOr5SXw+
 HYjDH/mGnzgNG9araz5o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.2013, Sarah Sharp wrote: 

> Heinz and Frantisek,
> I believe your issue should be fixed by this patch:
> 
> http://marc.info/?l=linux-usb&m=137476546506888&w=2
> 
> Please let me know if it doesn't.

Thanks a lot, it does fix it for me.

Heinz
