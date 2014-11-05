Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaKEQCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:02:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:26148 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbaKEQCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:02:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411879162"
Message-ID: <1415203295.958.133.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 03/35] UBI: Fastmap: Add self check to detect absent PEBs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 18:01:35 +0200
In-Reply-To: <545A48BD.9010904@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
		 <1414586758-9972-4-git-send-email-richard@nod.at>
	 <1415201029.958.118.camel@sauron.fi.intel.com> <545A48BD.9010904@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 16:56 +0100, Richard Weinberger wrote:
>  I did that to have alloc and free balanced.
> I.e. to not have a naked kfree(). Always when I see a kfree()
> somewhere
> I'd like to see the k*alloc().

OK. Please, just make the comment simpler then. Say that you are freeing
the debugging buffer or something.

