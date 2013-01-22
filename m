Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3AVQ3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:29:33 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:33701 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3AVQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:29:32 -0500
Message-ID: <50FEBE5D.7040905@xs4all.nl>
Date: Tue, 22 Jan 2013 17:29:17 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
CC: suravee.suthikulpanit@amd.com, Jacob Shin <jacob.shin@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450 <50FE9E76.30702@xs4all.nl> <50FEA3F2.1070408@amd.com> <50FEAFEB.7020103@xs4all.nl> <50FEBA69.60106@amd.com>
In-Reply-To: <50FEBA69.60106@amd.com>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-22 17:12, Boris Ostrovsky wrote:
>> Seen once over here. Correlated with raid-check.
> 
> Then the answer from Gigabyte doesn't prove anything. You can also boot
> Linux without seeing this problem in most cases.

That was my situation until the first time it hit.

> Your BIOS does not have the required erratum workaround. We will provide
> a patch to close that hole but since the problem is not easily
> reproducible (and the erratum is also not easy to trigger) it may be
> difficult to say whether it really helped with your problem.

Can we think of certain loads/actions/etc that could help trigger the issue?
Then if reproducing is easier we can better say if stuff is actually
fixed after the workaround.

Udo

