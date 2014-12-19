Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaLSCCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:02:13 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62700 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaLSCCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:02:10 -0500
Message-ID: <5493871F.6090404@gmail.com>
Date: Thu, 18 Dec 2014 19:02:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv v3] tools lib traceevent: Add support for IP address
 formats
References: <1418953390-28891-1-git-send-email-dsahern@gmail.com> <29144.1418954405@turing-police.cc.vt.edu>
In-Reply-To: <29144.1418954405@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/14 7:00 PM, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 18 Dec 2014 18:43:10 -0700, David Ahern said:
>> Adds helper for following kernel formats:
>>    %pi4 print an IPv4 address with leading zeros
>>    %pI4 print an IPv4 address without leading zeros
>>    %pi6 print an IPv6 address without colons
>>    %pI6 print an IPv6 address with colons
>>    %pI6c print an IPv6 address with colons
>
> %pI6c print an IPv6 address *in compressed form* with colons.
>

damn it. I misunderstood your comment before. Thanks for the follow up.

David
