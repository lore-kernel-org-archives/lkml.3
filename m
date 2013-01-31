Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab3AaW1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:27:15 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50198 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757007Ab3AaW1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:27:05 -0500
Message-ID: <1359671219.7527.3.camel@dabdike>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "dbasehore ." <dbasehore@chromium.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Fri, 01 Feb 2013 09:26:59 +1100
In-Reply-To: <CAGAzgsoa4XRsVz8UKVm-qZKmWNq+vsge-BBZewzmrRHSQm0k=A@mail.gmail.com>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	 <1356263388.15812.7.camel@dabdike.home>
	 <CAGAzgsoa4XRsVz8UKVm-qZKmWNq+vsge-BBZewzmrRHSQm0k=A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-31 at 14:02 -0800, dbasehore . wrote:
> (Resending message as plain text so it's tracked through vger lists)

Just FYI ... I don't get messages sent to me personally and the list, so
if it wasn't on vger, I haven't seen it.

> I didn't notice the other call to async_synchronize_full, I'll remove that one.
> 
> I split up the functionality of sd_start_stop_device to ensure that
> the command to start the disk was sent before resume was completed.
> For now, it's open coded, but that could be changed if I make
> additions are made to scsi_lib.c to allow us to return immediately
> after scheduling the command.

That would be better; I'll wait to see the proposed patch.

James


