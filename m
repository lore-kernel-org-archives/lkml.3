Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbaALPkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 10:40:25 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51853 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaALPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 10:40:23 -0500
Message-ID: <52D2B763.2050301@gmail.com>
Date: Sun, 12 Jan 2014 08:40:19 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, acme@infradead.org
CC: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/9] perf, tools: fix BFD detection on opensuse
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org> <1389469379-13340-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1389469379-13340-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/14, 12:42 PM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> opensuse libbfd requires -lz -liberty to build. Add those
> to the BFD feature detection.
>

Fixes static builds on Fedora as well.

David

