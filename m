Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3BLSUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:20:48 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41655 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3BLSTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:19:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V8] kbuild: create a rule to run the pre-processor on *.dts files
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Stephen Warren <swarren@nvidia.com>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <5119425A.1090802@wwwdotorg.org>
References: <1360091188-24063-1-git-send-email-swarren@wwwdotorg.org> <20130208144527.0D8DD3E2C01@localhost> <51156D09.7060401@gmail.com> <20130208220448.EDA773E2C27@localhost> <51157F65.2050309@wwwdotorg.org> <5119425A.1090802@wwwdotorg.org>
Date: Tue, 12 Feb 2013 18:08:05 +0000
Message-Id: <20130212180805.556C93E1202@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 12:11:22 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/08/2013 08:45 AM, Grant Likely wrote:
> > On Tue,  5 Feb 2013 12:06:28 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
> >> passing them to dtc for final compilation. This allows the use of #define
> >> and #include within the .dts file.
> ...
> > I've applied this and was going to push it out, but I've just thought of
> > a problem that could be a show stopper. ...
> 
> Grant, I notice this showed up in next-20130211 as:
> 
> 22435f3 kbuild: create a rule to run the pre-processor on *.dts files
> 
> Was that intentional? I assumed you wanted me to rework this before
> you'd apply it, rather than sending an incremental patch.

Yes it was intentional. I sat on my hands w.r.t. this patch for long
enough that I didn't want to delay it any longer. However, I still want
a solution to the problem discussed above before it becomes a
maintenance disaster.

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
