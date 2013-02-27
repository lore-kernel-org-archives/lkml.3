Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3B0M1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:27:53 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36794 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3B0M1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:27:51 -0500
Date: Wed, 27 Feb 2013 13:27:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Roberto Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: add callgrind conversion tool
Message-ID: <20130227122746.GA8226@gmail.com>
References: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roberto Vitillo <ravitillo@lbl.gov> wrote:

> The proposed patch adds the convert tool to perf which allows to convert a 
> perf.data file to a callgrind data file which can subsequently be displayed with 
> kcachegrind. Callgraphs are not supported.

Would be nice to add a usecase description to the documentation that explains a good 
example of how to make use of this feature.

Thanks,

	Ingo
