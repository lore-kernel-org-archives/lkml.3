Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3IKULb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:11:31 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:42710 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3IKUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 11 Sep 2013 13:11:28 -0700
X-Google-Sender-Auth: VKfk3bMYr3zEOf6pcdCJUaQYqog
Message-ID: <CAGXu5jJt=uBFLL=VUy5L8=eO2eX_6-dm=c3Ck0JZ-YHovdSv_g@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] HID: validate report details
From: Kees Cook <keescook@chromium.org>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:56 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hi guys,
>
> here is the v3 of the CVE fixes.
>
> I have tested the multitouch and logitech-dj part, and the lenovo-tpkbd has been
> tested in the bug referenced in patch 10.
>
> Cheers,
> Benjamin
>
> Changes since v2:
> - fix lenovo-tpkbd report validation
> - fix lenovo-tpkbd not releasing the device when the report was not valid
> - use generic tests found in previous hid-multitouch patches, so that this will
>   not happen again
> - fix input_report index retrieving in hid-multitouch

Awesome! Thanks very much for fixing these up. I replied with Acks
where appropriate. :)

-Kees

-- 
Kees Cook
Chrome OS Security
