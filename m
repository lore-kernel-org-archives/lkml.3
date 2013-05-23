Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab3EWSfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:35:39 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:51406 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab3EWSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 May 2013 11:35:16 -0700
Message-ID: <CALCETrXd=6aJwQdDL+XU9x2Pnh0V_9120iw1NHaguN1ahRhhXQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Clean up write-combining MTRR addition
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 4:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> A fair number of drivers (mostly graphics) add write-combining MTRRs.
> Most ignore errors and most add the MTRR even on PAT systems which don't
> need to use MTRRs.
>
> This series adds new functions arch_phys_wc_{add,del} that, on PAT-less
> x86 systems with MTRRs, add MTRRs and report errors, and that do nothing
> otherwise.  (Other architectures, if any, with a similar mechanism could
> implement them.)

That's the path to upstream for this?  Should it go through drm-next?
(Sorry for possible noob question -- I've never sent in anything other
than trivial fixes to drm stuff before.)

--Andy
