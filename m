Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaKYPl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:41:57 -0500
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:56867 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYPlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:41:55 -0500
Message-ID: <1416930112.11944.2.camel@debian.org>
Subject: Re: [PATCH] of: support passing console options with stdout-path
From: Ian Campbell <ijc@debian.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Tue, 25 Nov 2014 15:41:52 +0000
In-Reply-To: <CACxGe6vekjF4M0J4s7g2Q_E-KYUrT_3Pna2z6nobSMZ7bc8Bhw@mail.gmail.com>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
	 <20141125145854.A46EDC44343@trevor.secretlab.ca>
	 <20141125151515.GG2361@bivouac.eciton.net>
	 <CACxGe6v2i3iJGjK9s6HSBxV6bUwVrAtGYj=FAOb0AFEx3KVYEg@mail.gmail.com>
	 <1416929071.16769.1.camel@debian.org>
	 <CACxGe6vekjF4M0J4s7g2Q_E-KYUrT_3Pna2z6nobSMZ7bc8Bhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 15:39 +0000, Grant Likely wrote:
> On Tue, Nov 25, 2014 at 3:24 PM, Ian Campbell <ijc@debian.org> wrote:
> >> sed s/of_find_node_by_path\((.*)\)/of_find_node_by_path\(\1, NULL\)
> >
> > Coccinelle rules for this sort of transformation...
> 
> /me still hasn't gotten his head around how to use Coccinelle properly. :-(

Me neither, but for the "add an extra NULL parameter" case I can
generally find something to cargo cult from ;-) (it's been ages since I
had a need though)

Ian.

