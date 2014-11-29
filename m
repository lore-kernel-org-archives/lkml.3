Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaK2LBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 06:01:19 -0500
Received: from mout.gmx.net ([212.227.15.15]:61226 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaK2LBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 06:01:18 -0500
Message-ID: <5479A76F.5050809@gmx.de>
Date: Sat, 29 Nov 2014 12:01:03 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Hisashi T Fujinaka <htodd@twofifty.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000: remove unused variables
References: <1417065728-5592-1-git-send-email-sudipm.mukherjee@gmail.com> <alpine.NEB.2.11.1411262157110.1481@chris.i8u.org> <20141127130725.GA12406@sudip-PC> <54790537.809@gmail.com>
In-Reply-To: <54790537.809@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:S+d0DoIWOv6qBCdz9hbVuBKdHyam2gmXu8dWeb5PfOqHjXxoLbD
 za774AcIdvZ0E/Z43Hk566UQV2dYG+7Xnc2Qpj6hfD+zDj4/vTKvkVOaYnQ9HKbcnnO+OLe
 lMWwlIqOlugXqdKTLPqMUEbD/2mpYjmpbE4rEXqa8tb/myrNg4MB2bP4QkpGUhdoosy9FiD
 SOkhuwnUQneZYXUFzw1aw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2014 00:28, Florian Fainelli wrote:

> Also, if you do a read that is not stored in any return value, the
> compiler is now free to remove that actual read, 

This does not apply to reads from iomem (see "volatile" specifier in
readl()).

Regards,
Lino

