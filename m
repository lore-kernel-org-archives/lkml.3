Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3C0O2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:28:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39723 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3C0O2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:28:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303271410510.23442@pobox.suse.cz>
References: <1363974837-8958-1-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1303271410510.23442@pobox.suse.cz>
Date: Wed, 27 Mar 2013 15:28:48 +0100
Message-ID: <CAN+gG=EdM_96yWic4OQdQKzR-CYh8PBdr6mTaaQQVP1-7HYySg@mail.gmail.com>
Subject: Re: [PATCH v3.9+] HID: multitouch: fix touchpad buttons
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 2:11 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> I don't think it's a big deal (to my knowledge, no retail product uses this
>> feature), but it's still a regression in 3.9.
>
> I am queuing this for 3.9 still, thanks.
>
> Benjamin, just please double-check that the patch is ok as-is in my
> for-3.9/upstream-fixes branch, as I had to hand-apply it due to
> context-related conflicts.
>

The patch looks good to me. I've run the tests against the touchpad,
and it's ok with this version.
So thanks for applying it manually (and sorry).

Cheers,
Benjamin
