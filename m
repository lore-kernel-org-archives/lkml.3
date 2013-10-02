Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3JBStE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:49:04 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:41050 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3JBStB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:49:01 -0400
Date: Wed, 02 Oct 2013 13:48:58 -0500
From: Rob Landley <rob@landley.net>
Subject: Status of "kernel crypto services" patch? Re: [PATCH]
 Documentation: "kerneli" typo in description for "Serpent cipher algorithm"
 Bug #60848
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Kevin Mulvey <kevin@kevinmulvey.net>, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, astor@fast.no
References: <1380730237-42543-1-git-send-email-kevin@kevinmulvey.net>
	<1380737551.1974.127@driftwood> <524C645E.9030800@iki.fi>
In-Reply-To: <524C645E.9030800@iki.fi> (from jussi.kivilinna@iki.fi on Wed
	Oct  2 13:22:22 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380739738.1974.129@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 01:22:22 PM, Jussi Kivilinna wrote:
> On 02.10.2013 21:12, Rob Landley wrote:
> > On 10/02/2013 11:10:37 AM, Kevin Mulvey wrote:
> >> change kerneli to kernel as well as kerneli.org to kernel.org
> >>
> >> Signed-off-by: Kevin Mulvey <kevin@kevinmulvey.net>
> >
> > There's a bug number for this?
> >
> > Acked, queued. (Although I'm not sure the value of pointing to  
> www.kernel.org for this.)
> 
> I think kerneli.org is correct.. see old website at  
> http://web.archive.org/web/20010201085500/http://www.kerneli.org/

Should I have the update link to the archive.org page, or...?

The above links to http://www.kernel.org/pub/linux/kernel/crypto which  
has patches for the 2.5 kernel circa 2003. Did this get merged, or  
dropped, or what?

(Documentation maintainership does not mean domain expert in  
everything, it's somewhere between librarian and janitor. Please tell  
me what to do here.)

Rob