Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3AUOoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:44:44 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:54916 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3AUOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:44:43 -0500
Message-ID: <50FD544B.6000806@xs4all.nl>
Date: Mon, 21 Jan 2013 15:44:27 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
CC: =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic> <20130120115755.GO25591@8bytes.org> <50FD52AB.9080000@amd.com>
In-Reply-To: <50FD52AB.9080000@amd.com>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-21 15:37, Boris Ostrovsky wrote:
>>> Btw, can't we add a quirk to disable NB clock gating? Maybe Boris and
>>> Jacob could help. CCed.
> 
> 
> Are you talking about erratum 746?

Link please?
If we have a link I could add that to the Gigabyte case.

Udo

