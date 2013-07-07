Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3GGQTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 12:19:47 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:44091 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3GGQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 12:19:44 -0400
Message-ID: <51D9951E.4050807@kernel.org>
Date: Sun, 07 Jul 2013 19:19:42 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] slob: Check for NULL pointer before calling ctor()
References: <1358442826.23211.18.camel@gandalf.local.home> <1360073811.27007.13.camel@gandalf.local.home> <0000013caadd2e2f-3ca39b5e-cc18-4a38-9485-d505a89098af-000000@email.amazonses.com>
In-Reply-To: <0000013caadd2e2f-3ca39b5e-cc18-4a38-9485-d505a89098af-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/13 4:58 PM, Christoph Lameter wrote:
> On Tue, 5 Feb 2013, Steven Rostedt wrote:
>
>> Ping?
>
> Obviously correct.
>
> Acked-by: Christoph Lameter <cl@linux.com>

Applied, thanks a lot!

