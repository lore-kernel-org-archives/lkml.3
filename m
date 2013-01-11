Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3AKNBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:01:25 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56210 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3AKNBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:01:24 -0500
Message-ID: <1357909236.4146.29.camel@falcor>
Subject: Re: Friendlier EPERM - Request for input
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Date: Fri, 11 Jan 2013 08:00:36 -0500
In-Reply-To: <1357835679.1342.45.camel@localhost>
References: <1357747463.2593.28.camel@localhost>
	 <1357760637.2593.55.camel@localhost>
	 <201301110014.CDB90164.MFtFHVSQOFOJLO@I-love.SAKURA.ne.jp>
	 <1357835679.1342.45.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011113-9360-0000-0000-00000F10A834
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 11:34 -0500, Eric Paris wrote:
> Friendlier/more complete error messages would eliminate an awful lot of
> digging around trying to figure *what* the problem is, preparatory to
> discerning *where* the problem is and *how* to fix it.

Agreed, add to the mix of existing issues, with the upstreaming of
IMA-appraisal, failure when enforcing integrity.

Mimi

