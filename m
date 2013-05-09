Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3EIIma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:42:30 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55713 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3EIImV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:42:21 -0400
Message-ID: <518B6164.6040707@gmail.com>
Date: Thu, 09 May 2013 12:42:12 +0400
From: Denis <yefremov.denis@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH 02/21] fs: remove inline marking of EXPORT_SYMBOL functions
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com> <1368086323-9412-2-git-send-email-yefremov.denis@gmail.com> <20130509080742.GE25399@ZenIV.linux.org.uk>
In-Reply-To: <20130509080742.GE25399@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.05.2013 12:07, Al Viro wrote:
> On Thu, May 09, 2013 at 11:58:24AM +0400, Denis Efremov wrote:
>> EXPORT_SYMBOL and inline directives are contradictory to each other.
>> The patch fixes this inconsistency.
> What makes them contradictory, in your opinion?  With references to
> relevant parts of C99, please.
Looks like the introductory message was rejected by mailing list.
Will try to do something with this. You can find it here:
http://linuxtesting.org/pipermail/ldv-project/2013-May/000101.html

Patchset is based on previous fixes.
