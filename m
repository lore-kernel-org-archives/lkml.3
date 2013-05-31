Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3EaDRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:17:01 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:37256 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3EaDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:16:56 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXd=6aJwQdDL+XU9x2Pnh0V_9120iw1NHaguN1ahRhhXQ@mail.gmail.com>
References: <cover.1368485053.git.luto@amacapital.net>
	<CALCETrXd=6aJwQdDL+XU9x2Pnh0V_9120iw1NHaguN1ahRhhXQ@mail.gmail.com>
Date: Fri, 31 May 2013 13:16:54 +1000
Message-ID: <CAPM=9tx87GFyGzgC+q3daUk5hP6GOJYXcKBnRE4d2ujC_LLALA@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Clean up write-combining MTRR addition
From: Dave Airlie <airlied@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 4:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, May 13, 2013 at 4:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> A fair number of drivers (mostly graphics) add write-combining MTRRs.
>> Most ignore errors and most add the MTRR even on PAT systems which don't
>> need to use MTRRs.
>>
>> This series adds new functions arch_phys_wc_{add,del} that, on PAT-less
>> x86 systems with MTRRs, add MTRRs and report errors, and that do nothing
>> otherwise.  (Other architectures, if any, with a similar mechanism could
>> implement them.)
>
> That's the path to upstream for this?  Should it go through drm-next?
> (Sorry for possible noob question -- I've never sent in anything other
> than trivial fixes to drm stuff before.)

I've pulled the v3 series into drm-next, lets see how they go for a while,

I suppose I should try and boot an AGP box with them.

Dave.
