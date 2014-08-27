Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaH0AeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:34:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaH0AeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:34:07 -0400
Message-ID: <1409099608.21254.16.camel@smoke>
Subject: Re: [PATCH 0/5] kexec: minor fixups and enhancements
From: Geoff Levand <geoff@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 26 Aug 2014 17:33:28 -0700
In-Reply-To: <20140825165916.GC14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
	 <20140825165916.GC14379@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Mon, 2014-08-25 at 12:59 -0400, Vivek Goyal wrote:
> Does arm64 has secureboot? If yes, then it might make sense to
> enable the new syscall kexec_file_load() on arm64 instead of trying
> to make old syscall work first.

Yes, arm64 should support secureboot, but I have not looked into it.

When do you expect syscall kexec_file_load to get merged?  I won't wait
until then to push my current kexec work.

-Geoff

