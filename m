Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaAKLok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:44:40 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:42679 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaAKLog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140111113959.GW30234@mwanda>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
	<1389438033-5928-1-git-send-email-monamagarwal123@gmail.com>
	<20140111111931.GV30234@mwanda>
	<CAFB2WuU=aGwVM7n1Zy7OSnEaR00ZWyPNXGw9A5MBk1p0+LSKZg@mail.gmail.com>
	<20140111113959.GW30234@mwanda>
Date: Sat, 11 Jan 2014 17:14:35 +0530
Message-ID: <CAFB2WuUaf9x42U0xTyczpw1=9kLaLLPC9v0f5JxpS7j+umt9kw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Staging: lustre: Refactor the function
 interval_erase_color() in /lustre/ldlm/interval_tree.c
From: Monam Agarwal <monamagarwal123@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        linux-kernel@vger.kernel.org,
        Rashika Kheria <rashika.kheria@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 5:09 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Jan 11, 2014 at 04:56:44PM +0530, Monam Agarwal wrote:
>> I took n as a flag to decide whether parent->in_left == node is true
>> or not in the called function.
>
> So "n" stands for "node"?
>
>> Should I use some other name for the flag.
>
>
> Yes.
>

Will "flag" be a suitable name?
