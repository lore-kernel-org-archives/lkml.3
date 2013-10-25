Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3JYPgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:36:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3JYPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:36:14 -0400
Message-ID: <526A8FE3.8040801@canonical.com>
Date: Fri, 25 Oct 2013 11:36:03 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, przanoni@gmail.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert "Revert "drm/i915:
 revert eDP bpp clamping code changes""
References: <cover.1381939165.git.joseph.salisbury@canonical.com> <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com> <20131016210213.GR4830@phenom.ffwll.local>
In-Reply-To: <20131016210213.GR4830@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 05:02 PM, Daniel Vetter wrote:
> On Wed, Oct 16, 2013 at 04:34:57PM -0400, Joseph Salisbury wrote:
>> BugLink: http://bugs.launchpad.net/bugs/1195483
>>
>> This reverts commit 657445fe8660100ad174600ebfa61536392b7624.
>>
>> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Paulo Zanoni <przanoni@gmail.com>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: stable@vger.kernel.org
> It's by far not that simple. Jani is working on both the underlying bug
> and a better w/a. See
>
> https://bugzilla.kernel.org/show_bug.cgi?id=59841
>
> for the full story in its entire glory.
>
> Cheers, Daniel

Thanks for the feedback, Daniel.  Is there an estimate on what mainline
release might contain Jani's work?

Thanks again,

Joe
