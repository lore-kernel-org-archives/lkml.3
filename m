Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3BALSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:18:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3BALSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:18:42 -0500
MIME-Version: 1.0
In-Reply-To: <510B7DC6.10803@jp.fujitsu.com>
References: <1359688060-12964-1-git-send-email-ming.lei@canonical.com>
	<510B7DC6.10803@jp.fujitsu.com>
Date: Fri, 1 Feb 2013 19:18:39 +0800
Message-ID: <CACVXFVOcRh7oFKNXV8jM8TYw833ErkS=Le9UnZEGAhbRi8=5aA@mail.gmail.com>
Subject: Re: [PATCH] block: partition: optimize memory allocation in check_partition
From: Ming Lei <ming.lei@canonical.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@ti.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 4:33 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:

> At least, you should use release_partitions() instead of kfree() here.

Good catch, thank you for pointing it out, and I will post v1 later
with the update.

Thanks,
--
Ming Lei
