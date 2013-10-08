Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3JHAha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:37:30 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59042 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3JHAh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <1381192140.2081.235.camel@joe-AO722>
References: <1381189523.2081.225.camel@joe-AO722>
	<20131007165626.be437f74a4ba39e2be21af55@linux-foundation.org>
	<1381190594.2081.228.camel@joe-AO722>
	<CAErSpo75uQL5woms175LR4KCAmqT_SWpQcXGdbKccgVPdh6xhg@mail.gmail.com>
	<1381192140.2081.235.camel@joe-AO722>
Date: Mon, 7 Oct 2013 21:37:25 -0300
Message-ID: <CAGG-pUT4=T6L_OHk-abQNXChoMYrfh_cMTeqAS9JsZN8w8tbUA@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Add check for sscanf without return use
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/7 Joe Perches <joe@perches.com>:
> On Mon, 2013-10-07 at 18:10 -0600, Bjorn Helgaas wrote:
>> On Mon, Oct 7, 2013 at 6:03 PM, Joe Perches <joe@perches.com> wrote:
>> > On Mon, 2013-10-07 at 16:56 -0700, Andrew Morton wrote:
>> >> On Mon, 07 Oct 2013 16:45:23 -0700 Joe Perches <joe@perches.com> wrote:
>> >>

>
> Add a warning when the sscanf return value is not used.
>

It'll be nice.
