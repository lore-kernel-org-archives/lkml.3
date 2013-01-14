Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3ANRj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:39:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60934 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3ANRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:39:26 -0500
Message-ID: <50F442CA.5080909@gmail.com>
Date: Mon, 14 Jan 2013 10:39:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "devendra.aaru" <devendra.aaru@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: dso_load - move name malloc to when needed
References: <1358182250-89669-1-git-send-email-dsahern@gmail.com> <CAHdPZaPBd8evQsHbtNaToGnqSmUyuE_ZNNnPDLGCYD4i8p+sUA@mail.gmail.com>
In-Reply-To: <CAHdPZaPBd8evQsHbtNaToGnqSmUyuE_ZNNnPDLGCYD4i8p+sUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/13 10:38 AM, devendra.aaru wrote:
> On Mon, Jan 14, 2013 at 11:50 AM, David Ahern <dsahern@gmail.com> wrote:
>> memory is currently leaked on some paths.
>
> you are missing a signoff.

grr.... did that on all 3. I'll resend.

David

