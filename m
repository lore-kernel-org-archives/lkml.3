Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaBDR1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:27:11 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:56043 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBDR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:27:08 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: RE: [PATCH] of: fix of_update_property()
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Rob Herring <robherring2@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <b61be84c13ed4056a62743e16beb70f2@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389933996-19306-1-git-send-email-Li.Xiubo@freescale.com> < CAL_JsqJuAv8=pBuzYO5ZGzroD1kq6gjmNsTjoVyXR=vcu+-pTA@mail.gmail.com> < b61be84c13ed4056a62743e16beb70f2@BY2PR03MB505.namprd03.prod.outlook.com>
Date: Tue, 04 Feb 2014 17:26:59 +0000
Message-Id: <20140204172659.CEA26C4050F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014 05:50:17 +0000, "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com> wrote:
> > Subject: Re: [PATCH] of: fix of_update_property()
> > 
> > On Thu, Jan 16, 2014 at 10:46 PM, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> > > The of_update_property() is intent to update a property in a node
> > 
> > s/intent/indended/
> > 
> > > and if the property does not exist, will add it to the node.
> > >
> > > The second search of the property is possibly won't be found, that
> > > maybe removed by other thread just before the second search begain,
> > > if so just retry it.
> > 
> > How did you find this problem? Actual use or some artificial stress test?
> >
> 
> Some artificial stress test at home.

Can you reproduce those tests? It would be nice to have the selftests in
the kernel so that we can regression test for problems like this.

g.

