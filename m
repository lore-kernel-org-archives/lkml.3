Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3HWBMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:12:32 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33096 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3HWBMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:12:31 -0400
Message-ID: <5216B6FC.5050908@amacapital.net>
Date: Thu, 22 Aug 2013 18:12:28 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
References: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 05:03 PM, Andy Lutomirski wrote:
> Writes via mmap currently update mtime and ctime in ->page_mkwrite.

The subject should be [PATCH v4 0.7]...  Sorry for the cut-and-pasteo.

--Andy
