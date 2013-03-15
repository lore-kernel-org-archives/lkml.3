Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3COOxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:53:04 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44987 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab3COOxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:53:01 -0400
Message-ID: <514335C9.5000501@imgtec.com>
Date: Fri, 15 Mar 2013 14:52:57 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
CC: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH resend v5] fs: imgdafs: Add IMG DAFS filesystem for metag
References: <1362747737-27557-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1362747737-27557-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_15_14_52_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/13 13:02, James Hogan wrote:
> Add the IMG Debug Adapter File System (DAFS) for metag, which uses
> SWITCH operations to communicate with a file server on a host computer
> via a JTAG debug adapter.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
> This is pretty much a resend of v4, but separated from the arch/metag
> patchset. I didn't get any response beyond v1 so I excluded it from that
> patchset. I'd like to get it included in v3.10.

Ping. I'd like to get this accepted for v3.10, but haven't had a
response to it since October. Do new file systems like this normally go
through the official vfs tree or should I just take it through the metag
tree?

Cheers
James

