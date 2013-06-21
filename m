Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423067Ab3FUDAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:00:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51178 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422896Ab3FUDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130621013045.GJ23042@agk-dp.fab.redhat.com>
References: <1371763260-9933-1-git-send-email-gcondra@google.com>
	<20130621005905.GI23042@agk-dp.fab.redhat.com>
	<CAEQjtanyk2mw2LHMruU+4ujj4KsTtgyfh=3ABk+3g77Bn-6W3g@mail.gmail.com>
	<20130621013045.GJ23042@agk-dp.fab.redhat.com>
Date: Thu, 20 Jun 2013 20:00:12 -0700
Message-ID: <CAEQjtam6hHgGKqUwK2Lc=ADm25=E_k9jWWtknaTj9eeXhtUV8g@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] dm: verity: Add support for emitting uevents
 on dm-verity errors.
From: Geremy Condra <gcondra@google.com>
To: Geremy Condra <gcondra@google.com>, dm-devel@redhat.com, wad@chromium.org,
        linux-kernel@vger.kernel.org, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 6:30 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, Jun 20, 2013 at 06:12:07PM -0700, Geremy Condra wrote:
>> Assuming nobody currently using DM_UEVENT minds it doesn't cause any
>> problems for me. Any current users object?
>
> DM_UEVENT toggles uevents on or off across the whole of device-mapper.
>
> If there is no particular need for verity *not* to generate uevents
> while other parts of device-mapper *are* generating them, then we can
> make do with just the one Kconfig parameter.  (Userspace is still free
> to ignore particular events.)
>
> So let's drop the second config parameter.

SGTM, next patch coming up- thanks for taking the time to review!

Geremy Condra

>
> Alasdair
>
