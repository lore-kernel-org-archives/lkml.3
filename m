Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaK1Pk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:40:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaK1Pk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:40:28 -0500
Message-ID: <54789767.1080803@suse.cz>
Date: Fri, 28 Nov 2014 16:40:23 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] kbuild: Fix make help-<board series> on powerpc
References: <1417179145-30789-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1417179145-30789-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-28 13:52, Michal Marek wrote:
> make ARCH=powerpc help-<board series> should not require a cofigured
> source tree. Also, sort the boards in the output.

I added this to kbuild.git#kbuild.

Michal

