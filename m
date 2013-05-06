Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3EFNr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:47:56 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:57734 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab3EFNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:47:55 -0400
Date: Mon, 6 May 2013 13:47:34 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <CAOJsxLF2ND+x0Du=d7jUKZv+ggYJpbRZaZTbLazfW5qagGTFQA@mail.gmail.com>
Message-ID: <0000013e7a18ece4-2a323beb-8332-49f1-9864-65939641818c-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
 <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp> <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com> <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp> <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
 <CAOJsxLF2ND+x0Du=d7jUKZv+ggYJpbRZaZTbLazfW5qagGTFQA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.06-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Pekka Enberg wrote:

> This doesn't seem to apply against slab/next branch. What tree did you
> use to generate the patch?

Slab/next from a couple of weeks ago.

