Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3HBR4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:56:13 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33316 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3HBR4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <2112254.EC1eeAtOxW@vostro.rjw.lan>
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
	<51FB118D.8040205@gmail.com>
	<CAMP44s2KijzXcYyU_fOD2YB4rU5wuFCfte4fR3HXoriTKE2wuA@mail.gmail.com>
	<2112254.EC1eeAtOxW@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 12:56:09 -0500
Message-ID: <CAMP44s2oYm+iE-BYu93-bniTRPiu_LZWSAmAd8xEoNSZJbjemQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] acpi: video: trivial style cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 9:09 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, August 01, 2013 11:18:34 PM Felipe Contreras wrote:
>> On Thu, Aug 1, 2013 at 8:55 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
>> > On 08/02/2013 07:44 AM, Felipe Contreras wrote:
>> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >
>> > Change log please.
>>
>> You mean a commit message?
>
> No.  He meant the part that goes between the subject and the signoff.
> This is called a change log (or changelog).

Not in Git lingo.

% man git commit

"Though not required, it’s a good idea to begin the commit message
with a single short (less than 50 character) line summarizing the
change, followed by a blank line and then a more thorough
description."

>> That's what it's called in Git lingo, and
>> it's right there:
>>
>> acpi: video: trivial style cleanups
>
> And that's not sufficient, because it doesn't explain *what* cleanups are
> being made.

Yes it does; *style* cleanups (coding-style).

-- 
Felipe Contreras
