Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaFIFPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:15:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaFIFPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAOHikRCv6CRX-mYcd2qtv8-Xenwg6uudBWafoMOo-_Kfh=vZMg@mail.gmail.com>
References: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
	<CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
	<CACVXFVPHfP1VXujLx9sGt3c7ptdG1JvBQkw2JiJQsU1KwJ1zog@mail.gmail.com>
	<20140605134120.GA21607@htj.dyndns.org>
	<CACVXFVNUp3jfb1TVo7H7TNm4r2RaqDU0GDaMRq-DtB8ZEXaC+Q@mail.gmail.com>
	<1402023429.30026.4.camel@dwillia2-mobl2.amr.corp.intel.com>
	<CACVXFVPmc=1-oWL=bq9GH5BnJf4VBWoZEXkkLWBP_N3HbJrZkQ@mail.gmail.com>
	<CAOHikRCYF3ManA-YqCddXdRyD=pqwO_=oSnw2qZtGEnd+wvjaw@mail.gmail.com>
	<CACVXFVPnpwTLw2dBgJsCQNWGYJmjb4oe2=FnyK2cixGiXxJePw@mail.gmail.com>
	<CAOHikRCv6CRX-mYcd2qtv8-Xenwg6uudBWafoMOo-_Kfh=vZMg@mail.gmail.com>
Date: Mon, 9 Jun 2014 13:15:37 +0800
Message-ID: <CACVXFVOe9Bp2hr+B60DxOxzD5HM-U_fcCiYaj2ePVnhByo0rJw@mail.gmail.com>
Subject: Re: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag
 ordered controllers)
From: Ming Lei <ming.lei@canonical.com>
To: Suman Tripathi <stripathi@apm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Sun, Jun 8, 2014 at 12:51 PM, Suman Tripathi <stripathi@apm.com> wrote:
> Hi Ming,
>
> I have attached the  patches but it is not accepted by Tejun yet, So I will
> post another version.

OK, thanks.

Since Tejun didn't think it is a workable approach, I am not going test
the attachment, but I will look at / test your next version.

Also, Loc mentioned that only your early chip has the problem,
I am wondering why you don't take Dan's approach just
for the affected chips?


Thanks,
--
Ming Lei
