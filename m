Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaIPG4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:56:07 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40404 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaIPG4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:56:06 -0400
Date: Tue, 16 Sep 2014 08:56:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        akpm@linux-foundation.org, rientjes@google.com, andi@firstfloor.org,
        riel@redhat.com, yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] x86: numa: setup_node_data(): drop dead code and rename
 function
Message-ID: <20140916065600.GE14807@gmail.com>
References: <20140915142540.0a24c887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915142540.0a24c887@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luiz Capitulino <lcapitulino@redhat.com> wrote:

> The setup_node_data() function allocates a pg_data_t object, inserts it
> into the node_data[] array and initializes the following fields: node_id,
> node_start_pfn and node_spanned_pages.

Applied to the tip:x86/mm tree for v3.18 integration.

Thanks,

	Ingo
