Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaCHLHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:07:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:59154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCHLHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:07:50 -0500
Date: Sat, 8 Mar 2014 12:07:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/5] rcar_vin: add devicetree support
In-Reply-To: <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1403081148050.18310@axis700.grange>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
 <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:O+CiuVzjI9Bkp1GzQdytNXiI5Ieca+g50bysiE3xKAL
 xQphIw3z+/WgfJfiXQWwEsScuiY90Mly3dw0qmbCBVxlAcsytD
 +7sjuaUgPgcfN2sJeqefoWWb00mWpdkTvck9kHtnxdeBLDXBpt
 A/zwp6qvrV56ex4eHRtqMEa18R6eqK4rYtdM72Dal9hmg74Eym
 EmGb7OU8LYadDmOW8gDXqwqi0sbnym9YjoreKL6wbbNeXjEWVZ
 EmIlWprAdfzuVIHWzQ0PiKL4MnxiY/4XmJUye54MT4cHK26o/N
 hMPtBQt45bdeCEFb3PSBRCNO0S8UMsOV1NWsiFiTBL+8PPnjox
 jlOP4lV4vzvwaigZF5vAqeKySC2Q9G9HAZ6IEv8mVrs5Wsn+46
 s8s/YarmPZ0Ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, 7 Mar 2014, Ben Dooks wrote:

> Add support for devicetree probe for the rcar-vin
> driver.

Thanks for the patch. I'm afraid I don't quite understand how it is 
supposed to work though. AFAICS, the rcar_vin driver currently doesn't 
support asynchronous probing, so, your code is relying on a specific 
probing order? Besides, as of now soc-camera doesn't support OF probing. 
You mentioned, that you have a patch for soc-camera to add OF support. I 
think that and async probing for rcar_vin should be committed before this 
patch becomes meaningful.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
