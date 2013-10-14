Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3JNAnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 20:43:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3JNAnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 20:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
References: <1381682393-5769-1-git-send-email-ming.lei@canonical.com>
Date: Mon, 14 Oct 2013 08:42:57 +0800
Message-ID: <CACVXFVN3zy3V7=4S-v0fXscrPq3zWTiSdYJ_EaaqqX-UB4Cf3A@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix checking on nr_to_write
From: Ming Lei <ming.lei@canonical.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Ted Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:39 AM, Ming Lei <ming.lei@canonical.com> wrote:
>
> On one arm A15 board(arndale) with sata 3.0 SSD(CPU: 1.5GHz dura core, RAM: 2GB),

Sorry for forgetting to mention: the sata controller is working at 3.0Gbps.

Thanks,
--
Ming Lei
