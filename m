Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3HBESh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:18:37 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:65154 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3HBESg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <51FB118D.8040205@gmail.com>
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
	<1375400641-1694-3-git-send-email-felipe.contreras@gmail.com>
	<51FB118D.8040205@gmail.com>
Date: Thu, 1 Aug 2013 23:18:34 -0500
Message-ID: <CAMP44s2KijzXcYyU_fOD2YB4rU5wuFCfte4fR3HXoriTKE2wuA@mail.gmail.com>
Subject: Re: [PATCH 2/3] acpi: video: trivial style cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 8:55 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> On 08/02/2013 07:44 AM, Felipe Contreras wrote:
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> Change log please.

You mean a commit message? That's what it's called in Git lingo, and
it's right there:

acpi: video: trivial style cleanups

>> ---
>>  drivers/acpi/video.c | 90 +++++++++++++++++++++++-----------------------------
>>  1 file changed, 40 insertions(+), 50 deletions(-)
>>
>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>> index f021bf4..b07573f 100644
>> --- a/drivers/acpi/video.c
>> +++ b/drivers/acpi/video.c
>> @@ -88,7 +88,7 @@ module_param(allow_duplicates, bool, 0644);
>>  static bool use_bios_initial_backlight = 1;
>>  module_param(use_bios_initial_backlight, bool, 0644);
>>
>> -static int register_count = 0;
>> +static int register_count;
>
> This isn't a style clean up.

It is.

There's no difference before and after, the only difference is the style.

ERROR: do not initialise statics to 0 or NULL
#91: FILE: acpi/video.c:91:
+static int register_count = 0;

-- 
Felipe Contreras
