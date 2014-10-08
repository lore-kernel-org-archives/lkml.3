Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaJHJq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:46:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbaJHJqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:46:25 -0400
Date: Wed, 8 Oct 2014 11:46:20 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Hannes Frederic Sowa'" <hannes@stressinduktion.org>,
        Fabian Frederick <fabf@skynet.be>, Guenter Roeck <linux@roeck-us.net>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
Message-ID: <20141008094620.GA12270@unicorn.suse.cz>
References: <1412712996-4672-1-git-send-email-fabf@skynet.be>
 <20141007.161832.453892039501955243.davem@davemloft.net>
 <20141007203344.GA4748@roeck-us.net>
 <1559212122.19553.1412714971908.open-xchange@webmail.nmp.skynet.be>
 <1412715283.11600.11.camel@localhost>
 <063D6719AE5E284EB5DD2968C1650D6D174C6CA5@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174C6CA5@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 09:10:23AM +0000, David Laight wrote:
> From: Hannes Frederic Sowa
> > I think David's concern was whether if 0 == false in all situations. It
> > is pretty clear that static memory is initialized to 0.
> 
> I'm not 100% sure about that.
> static pointers may be required to be initialised to NULL.

ISO C 99 says:

  If an object that has static storage duration is not initialized
  explicitly, then:
  - if it has pointer type, it is initialized to a null pointer;
  - if it has arithmetic type, it is initialized to (positive or
    unsigned) zero;
  - if it is an aggregate, every member is initialized (recursively)
    according to these rules;
  - if it is a union, the first named member is initialized
    (recursively) according to these rules.

Michal Kubeèek

