Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3JaRMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:12:03 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:43837 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3JaRMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <87txfxml2b.fsf@intel.com>
References: <cover.1381939165.git.joseph.salisbury@canonical.com>
	<397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com>
	<20131016210213.GR4830@phenom.ffwll.local>
	<526A8FE3.8040801@canonical.com>
	<87txfxpjv1.fsf@intel.com>
	<CA+5PVA7j+90_iwZD+Gx9cAuqwEGH+cKB98OQj2+w4fhC_JT0pw@mail.gmail.com>
	<87txfxml2b.fsf@intel.com>
Date: Thu, 31 Oct 2013 13:11:59 -0400
X-Google-Sender-Auth: FmQcOZu-gxyQu3ZC8bmC7RVg5ME
Message-ID: <CA+5PVA7s8q1-N5Pz1N-zgEcn309LJUtwWvD+zWf=z3zv-UJ6TA@mail.gmail.com>
Subject: Re: [Intel-gfx] [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert
 "Revert "drm/i915: revert eDP bpp clamping code changes""
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, przanoni@gmail.com,
        Dave Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 1:01 PM, Jani Nikula
<jani.nikula@linux.intel.com> wrote:
> On Thu, 31 Oct 2013, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> On Thu, Oct 31, 2013 at 10:58 AM, Jani Nikula
>> <jani.nikula@linux.intel.com> wrote:
>>> On Fri, 25 Oct 2013, Joseph Salisbury <joseph.salisbury@canonical.com> wrote:
>>>> On 10/16/2013 05:02 PM, Daniel Vetter wrote:
>>>>> It's by far not that simple. Jani is working on both the underlying bug
>>>>> and a better w/a. See
>>>>>
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=59841
>>>>>
>>>>> for the full story in its entire glory.
>>>>>
>>>>> Cheers, Daniel
>>>>
>>>> Thanks for the feedback, Daniel.  Is there an estimate on what mainline
>>>> release might contain Jani's work?
>>>
>>> commit c6cd2ee2d59111a07cd9199564c9bdcb2d11e5cf
>>> Author: Jani Nikula <jani.nikula@intel.com>
>>> Date:   Mon Oct 21 10:52:07 2013 +0300
>>>
>>>     drm/i915/dp: workaround BIOS eDP bpp clamping issue
>>>
>>> and a couple of dependencies are now in Linus' tree, i.e. should be
>>> released in 3.12. The commits are also CC: stable.
>>
>> Are the dependency commits you mentioned these?
>
> Yes; sorry for not mentioning them explicitly.

No problem.  Thanks for confirming.

josh
