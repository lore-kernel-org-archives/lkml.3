Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936293Ab3DKVCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:02:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6637 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3DKVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:02:41 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=AegEXGf0JxkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YAZqD2d5wDAA:10 a=_hKRLuiY6XjEpHw_QTEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365714159.9609.64.camel@gandalf.local.home>
Subject: Re: [ 110/171 ] vfs: Add a mount flag to lock read only bind mounts
From: Steven Rostedt <rostedt@goodmis.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Date: Thu, 11 Apr 2013 17:02:39 -0400
In-Reply-To: <87vc7su6og.fsf@xmission.com>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202604.352966800@goodmis.org> <87vc7su6og.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 13:57 -0700, Eric W. Biederman wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > 3.6.11.2 stable review patch.
> > If anyone has any objections, please let me know.
> 
> Mounting only with privilege in the user namespace (where we use
> MNT_LOCK_READONLY) only dates back to 3.8 so this is not needed in 3.6.
> 
> Not that it should do any harm, but there doesn't seem to be much point
> in backporting this one.

OK, I'll drop it.

Thanks!

-- Steve


