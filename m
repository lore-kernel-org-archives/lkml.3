Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3FQLCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:02:13 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59653 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab3FQLCL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 17 Jun 2013 07:02:11 -0400
Message-Id: <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 17 Jun 2013 12:02:05 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>
Cc: "Zach Bobroff" <zacharyb@ami.com>, "Matt Fleming" <matt.fleming@intel.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>, "Joey Lee" <JLee@suse.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
In-Reply-To: <20130617101745.GB8569@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.06.13 at 12:17, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, 17 Jun, at 10:46:28AM, Jan Beulich wrote:
>> I agree that there ought to be an upper limit. But a single retry here
>> again looks like a tailored solution to a particular observed (mis-)
>> behavior, rather than something resulting from general considerations.
> 
> What value would you suggest for the retry?

I'd be considering something like 5...10, but this to some degree
depends on what odd kinds of behavior this in fact needs to
cover.

Jan

