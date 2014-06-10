Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaFJMhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:37:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaFJMhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:37:15 -0400
Message-ID: <5396FBF8.2060700@suse.cz>
Date: Tue, 10 Jun 2014 14:37:12 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>, Julia.Lawall@lip6.fr,
        Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCH V2] coccicheck: Add unneeded return variable test
References: <1401646351-12474-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1401646351-12474-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-01 20:12, Peter Senna Tschudin wrote:
> This semantic patch looks for variables that are initialized with a
> constant, are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied to kbuild.git#misc, thanks.

Michal

