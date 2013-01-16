Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3APSD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:03:26 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57956 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3APSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:03:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130116134201.GA20944@VPir>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
	<1358341251-10087-2-git-send-email-volokh84@gmail.com>
	<20130116133545.GG4584@mwanda>
	<20130116134201.GA20944@VPir>
Date: Wed, 16 Jan 2013 15:03:23 -0300
Message-ID: <CALF0-+XNKk6hXcd9EntHms38kUOKp4gkL3qq6wteUUo-+CqOdQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: media: go7007: firmware protection
 Protection for unfirmware load
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        mchehab@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        rdunlap@xenotime.net, hans.verkuil@cisco.com, justinmattock@gmail.com,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Volokh,

On Wed, Jan 16, 2013 at 10:42 AM, Volokh Konstantin <volokh84@gmail.com> wrote:
> On Wed, Jan 16, 2013 at 04:35:45PM +0300, Dan Carpenter wrote:
>> The problem is that the firmware was being unloaded on disconnect?
>>
> If no firmware was loaded (no exists,wrong or some error) then rmmod fails with OOPS,
> so need some protection stuff

This explanation should be part of the commit message.
It helps people understand what you're doing and why it's needed.

BTW, none of this 4-patch series has a detailed commit message
besides the commit title.
I know they are small patches, but I'm sure you can do better than that!

-- 
    Ezequiel
