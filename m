Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3ATWH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:07:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12843 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3ATWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:07:25 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=247Zj1P6LJsA:10 a=MrsYFV2JMfu00LwS6nkA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Sun, 20 Jan 2013 17:07:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: Borislav Petkov <bp@alien8.de>, Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: IPsec AH use of ahash
Message-ID: <20130120220721.GA5434@home.goodmis.org>
References: <20130120103132.GA16800@pd.tnic>
 <313650836.93071.1358686587647.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <313650836.93071.1358686587647.JavaMail.root@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 07:56:27AM -0500, Tom St Denis wrote:
> 
> You should really try running checkpatch.pl over code that's already in the kernel before you call out new contributors on it.
> 
> How is this supposed to not be adversarial when I can't even use the Kernel source itself as a reference?

So there's a lot of crap code in the kernel (that we are trying to clean
up when we have the time... see Kernel Janitors). But that's still no
excuse to allow more crap code to enter. That means adding more crap to
clean up.

-- Steve

