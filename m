Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaJWL2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:28:07 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:38973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaJWL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:28:03 -0400
Date: Thu, 23 Oct 2014 12:26:16 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matt Roper <matthew.d.roper@intel.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Thomas Wood <thomas.wood@intel.com>, Rob Clark <robdclark@gmail.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Benoit Taine <benoit.taine@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] GPU-DRM-GMA500: Deletion of unnecessary checks
 before two function calls
Message-ID: <20141023122616.4f66d31a@alan.etchedpixels.co.uk>
In-Reply-To: <5447DFD5.5020905@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5447DFD5.5020905@users.sourceforge.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 18:48:21 +0200
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> >> If you are convinced that dropping the null tests is a good idea, then you 
> >> can submit the patch that makes the change to the relevant maintainers and 
> >> mailing lists.
> 
> Would you like to integrate the following proposal into your source code repository?

What platforms have you tested the code on at this point ?

Alan
