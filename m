Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3ARV5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:57:09 -0500
Received: from mail-oa0-f62.google.com ([209.85.219.62]:55150 "EHLO
	mail-oa0-f62.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3ARV5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:57:06 -0500
X-Greylist: delayed 5711 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 16:57:06 EST
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Fri, 18 Jan 2013 12:21:55 -0800 (PST)
In-Reply-To: <fa.xKOV9tOmjA6NPYEPagvZixrd/4w@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=5.1.31.149; posting-account=RDa6jQoAAAD-XczVB65X4OwzXnvUfh11
NNTP-Posting-Host: 5.1.31.149
References: <fa.9LtpVDEImZxRAaqPOyWMlGOK4Ow@ifi.uio.no> <fa.xKOV9tOmjA6NPYEPagvZixrd/4w@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 5.1.31.149
MIME-Version: 1.0
Message-ID: <0a73688d-f466-4a96-89af-0dca4cb5ea8a@googlegroups.com>
Subject: Re: LIO - the broken iSCSI target implementation
From: promo@starwindsoftware.com
To: fa.linux.kernel@googlegroups.com
Cc: Andreas Steinmetz <ast@domdv.de>, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't start another "SCST Vs. LIO" holy war here. We all know why LIO belongs to Linux kernel and SCST does not.

On Friday, January 18, 2013 3:54:18 AM UTC+2, Vladislav Bolkhovitin wrote:
> Andreas Steinmetz, on 01/16/2013 08:19 PM wrote:
> 
> > Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
> 
> > technically favoured solution.
> 
> 
> 
> [...]
> 
> 
> 
> > The fun part of it was that I finally ended up using SCST - which was
> 
> > refrained from kernel inclusion for technical reasons beyond my
> 
> > knowledge.
> 
> 
> 
> No, it was purely political. There has never been any technical argument why LIO 
> 
> is better. And can not be.
> 
> 
> 
> Thanks,
> 
> Vlad
> 
> 
> 
> --
> 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> 
> the body of a message to majordomo@vger.kernel.org
> 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Please read the FAQ at  http://www.tux.org/lkml/

