Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaEOAca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:32:30 -0400
Received: from ns.horizon.com ([71.41.210.147]:57650 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751126AbaEOAc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:32:28 -0400
Date: 14 May 2014 20:32:25 -0400
Message-ID: <20140515003225.23627.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, pavel@ucw.cz
Subject: Re: [PATCH] lib/crc7: Shift crc7() output left 1 bit
Cc: arik@wizery.com, coelho@ti.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
In-Reply-To: <20140514195657.GA5320@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote;
> On Sun 2014-05-11 05:16:07, George Spelvin wrote:
>> To do it properly, I have to rename all of:
>> 
>> crc7_syndrome_table[]
>> crc7_byte()
>> crc7()
>> 
>> even though the third is the only (in-tree) user of the first two.

> If the first two are static, there's no problem.

They're not; they're exported from the header (even though, as
I mentioned, their only user is crc7()).

So my patch v2 1/3 renamed all three.
