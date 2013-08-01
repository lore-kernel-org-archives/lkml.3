Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3HAPOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:14:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38978 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab3HAPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:14:00 -0400
Date: Thu, 1 Aug 2013 16:13:52 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: core: init delayed_work for codec-codec links
Message-ID: <20130801151336.GA1112@opensource.wolfsonmicro.com>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com> <20130731132522.GP9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731132522.GP9858@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:25:22PM +0100, Mark Brown wrote:
> On Wed, Jul 31, 2013 at 02:16:44PM +0100, Richard Fitzgerald wrote:
> 
> > Pointing it to a dummy work callback is cleaner than taking
> > special cases in the code to bypass the flush_delayed_work_sync().
> 
> Why is this better than pointing at the normal work that you'd expect to
> be used there?

By 'normal work' do you mean the close_delayed_work() used for
standard PCM DAIs?
