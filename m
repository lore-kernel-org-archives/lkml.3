Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaJNKju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:39:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46899 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbaJNKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:39:49 -0400
Date: Tue, 14 Oct 2014 11:39:45 +0100
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v6] ASoC: dapm: add code to configure dai link
	parameters
Message-ID: <20141014103945.GA25013@opensource.wolfsonmicro.com>
References: <1412957836-2186-1-git-send-email-nikesh@opensource.wolfsonmicro.com> <20141010164959.GG18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010164959.GG18557@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 05:49:59PM +0100, Mark Brown wrote:
> On Fri, Oct 10, 2014 at 05:17:15PM +0100, Nikesh Oswal wrote:
> > dai-link params for codec-codec links were fixed. The fixed
> > link between codec and another chip which may be another codec,
> > baseband, bluetooth codec etc may require run time configuaration
> > changes. This change provides an optional alsa control to select
> > one of the params from a list of params.
> 
> Has anything changed since the previous version?  I've postponed
> reviewing that until after the merge window given the way you were
> ignoring feedback and the approach of the merge window, is this a new
> version or just a reposting.

>>> Since it was not merged or reviewed since long, I just did a  reposting 
of previous version of the patch
