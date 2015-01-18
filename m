Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbbARIf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 03:35:28 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:53700 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbbARIf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 03:35:26 -0500
Date: Sun, 18 Jan 2015 00:35:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Dudley Du <dudl@cypress.com>,
        rydberg@euromail.se, bleung@google.com, dso@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20150118083521.GF15720@dtor-ws>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <20150117104415.GA2083@hudson.localdomain>
 <20150117113904.GA2133@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150117113904.GA2133@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 03:39:04AM -0800, Jeremiah Mahler wrote:
> Dudley,
> 
> On Sat, Jan 17, 2015 at 02:44:15AM -0800, Jeremiah Mahler wrote:
> > Dudley,
> > 
> > Your patch series applies without issue but unfortunately I
> > could not test them because I ran in to a bug created by someone
> > elses patch (not yours) [1].
> > 
> >   [1]: https://lkml.org/lkml/2015/1/17/24
> > 
> > Once that issue gets resolved I would be happy to test your patch
> > series.
> > 
> 
> If I go back to linux-next 20150112 I can avoid the drm/i915 bug.
> Then, with this patch series applied, everything works well.
> Suspend/resume work, and the touchpad operates as expected.
> 
> Tested-by: Jeremiah Mahler <jmmahler@gmail.com>

OK, I believe that the code is in good shape now, so I queued all
patches for 3.20 (currently in my 'next' branch and should show in
linux-next soon). Any subsequent improvements to the code
should be relative to this series.

Jeremiah, thank you for testing the patches; Dudley thank you for your
patience with the process.

Thanks.

-- 
Dmitry
