Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3JYNma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:42:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44232 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753416Ab3JYNm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:42:29 -0400
Message-ID: <1382708539.18659.5.camel@pippen.local.home>
Subject: Re: [PATCH trace-cmd 2/5] build: Install data files without execute
 permissions
From: Steven Rostedt <rostedt@goodmis.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 25 Oct 2013 09:42:19 -0400
In-Reply-To: <20131025130534.GA24608@thinkpad-t410>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
	 <1382642074-15567-3-git-send-email-seth.forshee@canonical.com>
	 <1382689893.8356.2.camel@pippen.local.home>
	 <20131025130534.GA24608@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 08:05 -0500, Seth Forshee wrote:

> 
> If you disagree, it won't hurt my feelings if you drop those changes, so
> long as you keep the ones which makes sure things like .png files aren't
> executable ;-)

I pretty much don't care. I'll pull in the patches as is. I also had
Johannes Berg sitting next to me when I was reading your patch that
touched the python part of the build, and since him and Darren Hart were
the ones to add that, I had him give me a verbal "Reviewed-by".

-- Steve


