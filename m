Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaCRNaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:30:46 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:62860 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbaCRNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:30:19 -0400
Message-ID: <53284A66.10402@gmail.com>
Date: Tue, 18 Mar 2014 14:30:14 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mtk.manpages@gmail.com, NeilBrown <neilb@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: For review: open_by_name_at(2) man page
References: <53271B69.3000305@gmail.com> <20140318090007.3adee3d0@notabene.brown> <53283D7A.1020409@gmail.com> <20140318130708.GA13031@infradead.org>
In-Reply-To: <20140318130708.GA13031@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 02:07 PM, Christoph Hellwig wrote:
> That's why the file handles contain a generation counter that gets
> incremented in this case.

Ahh, yes. Thanks for the reminder/clue.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
