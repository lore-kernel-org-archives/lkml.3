Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3B1BUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:20:25 -0500
Received: from intranet.asianux.com ([58.214.24.6]:63092 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1BUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:20:22 -0500
X-Spam-Score: -100.8
Message-ID: <512EB0C2.6080301@asianux.com>
Date: Thu, 28 Feb 2013 09:20:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, roger.pau@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel <xen-devel@lists.xen.org>,
        dgdegra@tycho.nsa.gov,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used without initialized
References: <512D90F2.9070200@asianux.com> <512DE6B302000078000C1631@nat28.tlf.novell.com> <512DE213.3050001@asianux.com> <512DF1DF02000078000C16A4@nat28.tlf.novell.com> <20130227154002.GE24932@phenom.dumpdata.com>
In-Reply-To: <20130227154002.GE24932@phenom.dumpdata.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月27日 23:40, Konrad Rzeszutek Wilk 写道:
> On Wed, Feb 27, 2013 at 10:45:35AM +0000, Jan Beulich wrote:
>> > 
>> > Yes (and you might have missed the ACK that I had already sent
>> > before this reply - that mail got bounced for your address).
> Yup. Chen, could you respin the patch with the extra comment and
> the Ack from Jan please?

  ok, I will send patch v2.

  :-)

-- 
Chen Gang

Asianux Corporation
