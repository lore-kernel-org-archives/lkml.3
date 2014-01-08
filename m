Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbaAHVpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:45:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64055 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbaAHVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:45:03 -0500
Message-ID: <52CDC6D5.9040308@gmail.com>
Date: Wed, 08 Jan 2014 14:44:53 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, artagnon@gmail.com
Subject: Re: [PATCH 6/8] perf tools: Make --raw-dump work as a proper option
 for perf list.
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com> <20140108152032.GE2626@infradead.org>
In-Reply-To: <20140108152032.GE2626@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/14, 8:20 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 30, 2013 at 10:26:41AM -0500, Dongsheng Yang escreveu:
>> >Ramkumar reported that perf list --raw-dump was broken by 44d742e.
>> >Fix by making raw-dump a proper argument.
>> >
>> >Signed-off-by: David Ahern<dsahern@gmail.com>
> Are you sure David Signed-off-by' this, isn't this just an Acked-by or
> perhaps a Reviewed-by? David?

I thought the last version of the patch came from Ramkumar.

This version seems like an add-on to the last patch.

David
