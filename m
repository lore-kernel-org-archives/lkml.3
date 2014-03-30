Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaC3VEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:04:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:59284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaC3VEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:04:43 -0400
Date: Sun, 30 Mar 2014 23:04:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/5] rcar_vin: add devicetree support
In-Reply-To: <Pine.LNX.4.64.1403081148050.18310@axis700.grange>
Message-ID: <Pine.LNX.4.64.1403302303490.12008@axis700.grange>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
 <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
 <Pine.LNX.4.64.1403081148050.18310@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Lz0oXW14UqFBrNJ5njL7QsY8iLZiFrFjlKRzN7wnFk3
 Mf9fFnbREsBLgM7abrozEt5ErtqThACUk3tJpmMZqo2ob8XyQg
 7hZ1X3+aCMKTX99gl+D1Md98Iqqd0js6VOWKo1nu6GtqVLerM2
 l6/kRQezVgW/iWw4kIm9ylHDGA277qz1MuogB0idwHOfTgtOoh
 C2scyzIhUFYEzD7dTdm2+45cPvvbqcaecJILB+cwCR2oAQXAHg
 uhrafnQN9KXeXi6SXVCrrN1ICulf5J95chBO6ifWECd8Nc40Rz
 4TFzoDinArO18tHE13SuCk60Wi41wcMxHsEb1+SQN5v9utZPc/
 5T/emL56kIXfEoIXwaVelaGYbDO0CaYoTjUMw3DuUjNS50FEbi
 EE8zAJ9tcEjLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Since I never received a reply to this my query, I consider this your 
patch series suspended.

Thanks
Guennadi

On Sat, 8 Mar 2014, Guennadi Liakhovetski wrote:

> Hi Ben,
> 
> On Fri, 7 Mar 2014, Ben Dooks wrote:
> 
> > Add support for devicetree probe for the rcar-vin
> > driver.
> 
> Thanks for the patch. I'm afraid I don't quite understand how it is 
> supposed to work though. AFAICS, the rcar_vin driver currently doesn't 
> support asynchronous probing, so, your code is relying on a specific 
> probing order? Besides, as of now soc-camera doesn't support OF probing. 
> You mentioned, that you have a patch for soc-camera to add OF support. I 
> think that and async probing for rcar_vin should be committed before this 
> patch becomes meaningful.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
